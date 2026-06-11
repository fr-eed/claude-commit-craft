#if canImport(AppKit)
import AppKit

// macOS reuses one field editor (an NSTextView) to edit every text field in a
// window, recording keystroke undo in a per-cell NSCellUndoManager bound to the
// field's backing view. SwiftUI tears down `.id`-keyed text views directly,
// without ending the edit session, so that undo manager is left holding actions
// that reference freed views; replaying one (Cmd-Z) messages freed memory and
// crashes. Ending the edit session drains that stack.
//
// Call this before swapping a subtree that hosts an actively edited text field.
@MainActor
public enum FieldEditorUndo {
    public static func reset(in window: NSWindow) {
        // Ending the session invalidates the NSCellUndoManager; draining first
        // covers any action that would outlive the resign.
        (window.firstResponder as? NSText)?.undoManager?.removeAllActions()
        window.makeFirstResponder(nil)
    }
}
#endif
