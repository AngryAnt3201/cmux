import Foundation
@testable import CmuxMobileShell

/// In-memory ``TerminalDraftStoring`` test double shared by the composer draft
/// suites. Mirrors ``TerminalDraftStore``'s semantics — an empty or
/// whitespace-only save means "no draft" and drops the entry — without touching
/// the filesystem, so tests assert on exactly what the composite persisted.
actor InMemoryTerminalDraftStore: TerminalDraftStoring {
    private var drafts: [String: String] = [:]

    func draft(forTerminalID terminalID: String) -> String? {
        drafts[terminalID]
    }

    func saveDraft(_ draft: String, forTerminalID terminalID: String) {
        if draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            drafts[terminalID] = nil
        } else {
            drafts[terminalID] = draft
        }
    }

    func clearDraft(forTerminalID terminalID: String) {
        drafts[terminalID] = nil
    }

    func clearAllDrafts() {
        drafts.removeAll()
    }
}
