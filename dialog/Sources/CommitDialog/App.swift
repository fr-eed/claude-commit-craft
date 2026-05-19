import AppKit
import CoreGraphics
import SwiftUI
import CommitDialogCore

// Can become key with .borderless + .nonactivatingPanel (regular NSWindow can't).
final class OverlayPanel: NSPanel {
    override var canBecomeKey: Bool { true }
}

// Floats the panel above all Spaces (incl. fullscreen) without stealing focus.
// Re-applies the window config when screen/space changes (macOS sometimes resets level otherwise).
@MainActor  // NSWindow property mutations are main-actor-isolated
final class AppDelegate: NSObject, NSApplicationDelegate {
    private var panel: OverlayPanel?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)  // no Dock icon; treat as utility

        let store = makeStoreFromArgv()
        let content = ContentView().environmentObject(store)

        // Height leaves room for the optional BranchWarning banner without squeezing
        // the rest of the layout. CommitTab's body editor grows to fill the extra space when no banner is shown.
        let p = OverlayPanel(
            contentRect: NSRect(x: 0, y: 0, width: 720, height: 600),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        p.center()
        p.contentView = NSHostingView(rootView: content)
        p.isMovableByWindowBackground = true
        p.isReleasedWhenClosed = false
        p.hasShadow = true
        p.worksWhenModal = true

        // .borderless panels are flat; round the layer instead. Shadow follows alpha.
        p.contentView?.wantsLayer = true
        p.contentView?.layer?.cornerRadius = 12
        p.contentView?.layer?.masksToBounds = true

        self.panel = p

        configureWindow()  // also calls orderFrontRegardless()
        p.makeKeyAndOrderFront(self)

        // assumeIsolated: callbacks fire on .main, but @Sendable closure types aren't isolated.
        let center = NotificationCenter.default
        for name in [
            NSWindow.didBecomeKeyNotification,
            NSWindow.didChangeScreenNotification,
            NSApplication.didChangeScreenParametersNotification
        ] {
            center.addObserver(forName: name, object: nil, queue: .main) { [weak self] _ in
                MainActor.assumeIsolated { self?.configureWindow() }
            }
        }
        NSWorkspace.shared.notificationCenter.addObserver(
            forName: NSWorkspace.activeSpaceDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            MainActor.assumeIsolated { self?.configureWindow() }
        }
    }

    private func configureWindow() {
        guard let p = panel else { return }
        p.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.overlayWindow)))
        p.collectionBehavior = [
            .canJoinAllSpaces,
            .fullScreenAuxiliary,
            .ignoresCycle
        ]
        p.isOpaque = false
        p.backgroundColor = .clear
        p.hidesOnDeactivate = false
        p.orderFrontRegardless()
    }

}

// I/O model: read plan JSON from stdin (or argv[1] for manual testing); write result
// to stdout (or argv[2] for manual testing). Parsing lives in CommitDialogCore.
@MainActor
private func makeStoreFromArgv() -> PlanStore {
    let args = CommandLine.arguments

    let data: Data
    if args.count >= 2 {
        do {
            data = try Data(contentsOf: URL(fileURLWithPath: args[1]))
        } catch {
            die("Cannot read \(args[1]): \(error)")
        }
    } else {
        data = FileHandle.standardInput.readDataToEndOfFile()
    }

    let plan: CommitPlan
    do {
        plan = try PlanIO.parse(from: data)
    } catch {
        die("Invalid plan JSON: \(error)")
    }

    let outputPath: String? = args.count >= 3 ? args[2] : nil
    return PlanStore(initial: plan.commits, branch: plan.branch, repo: plan.repo, outputPath: outputPath)
}

private func die(_ message: String) -> Never {
    FileHandle.standardError.write(Data("\(message)\n".utf8))
    exit(2)
}

@main
struct CommitDialogApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    // The actual window is created in AppDelegate; this Settings scene is just a stub
    // so SwiftUI App lifecycle is satisfied. Settings scenes don't auto-open.
    var body: some Scene {
        Settings { EmptyView() }
    }
}
