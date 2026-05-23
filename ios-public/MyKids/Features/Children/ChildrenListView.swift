import SwiftUI

struct ChildrenListView: View {
    @Environment(AppSession.self) private var session
    @StateObject private var viewModel: ChildrenViewModel
    @State private var showAddChild = false
    @State private var editingChild: Child?
    @State private var childToDelete: Child?
    @State private var showInviteAccept = false

    init(session: AppSession) {
        _viewModel = StateObject(wrappedValue: ChildrenViewModel(session: session))
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.children.isEmpty {
                    ProgressView("Loading…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.children.isEmpty {
                    emptyState
                } else {
                    childList
                }
            }
            .navigationTitle("My Children")
            .toolbar { toolbarItems }
            .sheet(isPresented: $showAddChild) {
                AddChildView(viewModel: viewModel)
            }
            .sheet(item: $editingChild) { child in
                AddChildView(viewModel: viewModel, editingChild: child)
            }
            .sheet(isPresented: $showInviteAccept) {
                AcceptInviteView(session: session) { _ in
                    Task { await viewModel.load() }
                }
            }
            .confirmationDialog(
                "Delete \(childToDelete?.name ?? "")?",
                isPresented: Binding(
                    get: { childToDelete != nil },
                    set: { if !$0 { childToDelete = nil } }
                ),
                presenting: childToDelete
            ) { child in
                Button("Delete", role: .destructive) {
                    Task { await viewModel.deleteChild(child) }
                }
                Button("Cancel", role: .cancel) {}
            } message: { _ in
                Text("All events for this child will be deleted. This cannot be undone.")
            }
            .alert("Error", isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Button("OK", role: .cancel) { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .task { await viewModel.load() }
        }
    }

    private var childList: some View {
        List {
            ForEach(viewModel.children) { child in
                NavigationLink {
                    EventListView(child: child, session: session)
                } label: {
                    ChildRowView(child: child)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        childToDelete = child
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    Button {
                        editingChild = child
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    .tint(.blue)
                }
            }
        }
        .refreshable { await viewModel.load() }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "figure.2.and.child.holdinghands")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
                .symbolRenderingMode(.hierarchical)
            Text("No Children Yet")
                .font(.headline)
            Text("Tap + to add your first child")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            if session.isLoggedIn {
                Button("Accept Invite") { showInviteAccept = true }
                    .buttonStyle(.bordered)
                    .padding(.top, 8)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ToolbarContentBuilder
    private var toolbarItems: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            Button { showAddChild = true } label: {
                Image(systemName: "plus")
            }
        }
        if session.isLoggedIn {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { showInviteAccept = true } label: {
                    Image(systemName: "person.badge.plus")
                }
            }
        }
    }
}

struct ChildRowView: View {
    let child: Child

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f
    }()

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color.accentColor.opacity(0.15))
                    .frame(width: 48, height: 48)
                Text(child.name.prefix(1).uppercased())
                    .font(.title2.bold())
                    .foregroundStyle(Color.accentColor)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(child.name)
                    .font(.headline)
                if let bd = child.birthDate {
                    Text(Self.dateFormatter.string(from: bd))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
