#if canImport(UIKit)
import Observation
import UIKit

/// Cross-layer handle that lets the SwiftUI composer borrow the terminal's docked
/// accessory toolbar (`inputProxy.toolbarView`) while it is open.
///
/// The composer (``TerminalComposerView``) and the terminal surface
/// (`GhosttySurfaceView`, via ``GhosttySurfaceRepresentable``) are sibling SwiftUI
/// views with no direct reference to one another. Round 5 docks the toolbar BELOW
/// the composer field (so the field grows upward and pushes only the terminal,
/// while the modifier/arrow/Ctrl row stays pinned to the keyboard edge). That
/// requires hosting the toolbar inside the composer's `safeAreaInset`, but the
/// toolbar UIView lives deep in the terminal package.
///
/// This holder is constructed once in ``WorkspaceDetailView`` and passed to both:
/// the representable publishes the surface's toolbar into ``toolbarView`` when the
/// composer is active (and clears it when it closes), and the composer reads it to
/// mount it below its field. The surface fully relinquishes the toolbar while it is
/// checked out (it stops touching the view's `isHidden`/`frame`), so the composer's
/// Auto Layout owns it without a tug-of-war.
@MainActor
@Observable
final class ComposerToolbarHandoff {
    /// The borrowed docked accessory toolbar, or `nil` when the composer is closed
    /// and the surface owns it. Set by ``GhosttySurfaceRepresentable`` from the
    /// surface; read by ``TerminalComposerView`` to host below the compose field.
    var toolbarView: UIView?

    init() {}
}
#endif
