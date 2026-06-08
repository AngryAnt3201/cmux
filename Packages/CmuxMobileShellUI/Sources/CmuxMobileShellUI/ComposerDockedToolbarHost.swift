#if os(iOS)
import SwiftUI
import UIKit

/// Hosts the terminal's docked accessory toolbar (modifier / arrow / Ctrl row)
/// below the composer's compose field.
///
/// Round 5 re-orders the bottom stack to terminal / composer / toolbar / keyboard:
/// the toolbar rides the keyboard edge and "stays put" while the compose field
/// grows upward and pushes only the terminal. The toolbar is the SAME single
/// `inputProxy.toolbarView` the terminal surface owns the rest of the time; it is
/// handed across via ``ComposerToolbarHandoff``. Reparenting it here (an
/// `addSubview`) auto-removes it from the surface, which the surface tolerates while
/// it has the toolbar "checked out"; on dismiss the surface re-adopts it.
struct ComposerDockedToolbarHost: UIViewRepresentable {
    /// The borrowed toolbar view, published by ``GhosttySurfaceRepresentable``.
    /// The composer frames this host to the toolbar's button-row height
    /// (`GhosttySurfaceView.dockedToolbarHeight`); the toolbar is pinned full-bleed
    /// inside the host container so it fills that band edge-to-edge.
    let toolbarView: UIView

    func makeUIView(context: Context) -> UIView {
        let container = UIView()
        container.backgroundColor = .clear
        mount(toolbarView, in: container)
        return container
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // The published view can change identity if the surface is rebuilt while the
        // composer stays open (terminal switch). Re-seat it if so.
        if toolbarView.superview !== uiView {
            mount(toolbarView, in: uiView)
        }
    }

    private func mount(_ toolbar: UIView, in container: UIView) {
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(toolbar)
        NSLayoutConstraint.activate([
            toolbar.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            toolbar.topAnchor.constraint(equalTo: container.topAnchor),
            toolbar.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])
    }
}
#endif
