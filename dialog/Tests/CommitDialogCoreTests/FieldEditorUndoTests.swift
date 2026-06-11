#if canImport(AppKit)
import AppKit
import XCTest
@testable import CommitDialogCore

// Regression guard for the tab-switch Cmd-Z crash (see FieldEditorUndo for the
// mechanism). Reproduces the edit session, then asserts reset drains the
// field-editor undo stack and ends editing, so nothing replays into a freed view.
@MainActor
final class FieldEditorUndoTests: XCTestCase {
    func test_reset_endsEditingAndDrainsFieldEditorUndo() throws {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 200, height: 80),
            styleMask: [.titled],
            backing: .buffered,
            defer: false
        )
        let field = NSTextField(string: "abc")
        window.contentView?.addSubview(field)
        window.makeFirstResponder(field)

        // Simulate a keystroke so the field editor records an undoable action.
        let editor = try XCTUnwrap(field.currentEditor() as? NSTextView,
                                   "field should be in an edit session")
        editor.insertText("X", replacementRange: NSRange(location: 3, length: 0))

        // currentEditor().undoManager is the NSCellUndoManager from the crash.
        let cellUndo = try XCTUnwrap(editor.undoManager)
        XCTAssertTrue(cellUndo.canUndo, "precondition: a keystroke must be undoable")

        FieldEditorUndo.reset(in: window)

        XCTAssertFalse(cellUndo.canUndo, "reset must drain the field-editor undo stack")
        XCTAssertNil(field.currentEditor(), "reset must end the edit session")
    }
}
#endif
