# ⭕ Why You Should Use `git switch` and `git restore` Instead of `git checkout`

📅 Written at 2024-12-10 19:00:04

Git 2.23 introduced two experimental commands, `git switch` and `git restore`, as alternatives to `git checkout`. These commands are highly recommended because they make Git more intuitive and reduce the confusion caused by the multi-purpose nature of `git checkout`. This note explains why these commands were introduced, how they solve issues, and how to use them effectively.

---

## 🚩 Why Were `git switch` and `git restore` Introduced?

### 🔄 Problem with `git checkout`

The `git checkout` command is a versatile command that can:

- Switch branches: `git checkout my-branch`
- Create and switch to a new branch: `git checkout -b new-branch`
- Restore specific files: `git checkout -- myfile.txt`
- Restore files to a specific commit: `git checkout HEAD~3 -- myfile.txt`

This multi-functionality makes `git checkout` hard to understand for new users and error-prone for experienced ones.

### ✅ Solution: Separation of Responsibilities

Git 2.23 introduced two commands that split the responsibilities of `git checkout`:

- **`git switch`**: Focuses solely on branch-related operations (switching, creating, and tracking branches).
- **`git restore`**: Handles restoring files in the working tree or index.

This separation simplifies Git workflows, improves usability, and reduces the chance of user errors.

---

## 📖 How to Use `git switch` and `git restore`

### 1. **Switching and Creating Branches with `git switch`**

- **Switch to an existing branch**:
  ```bash
  git switch my-branch
  ```
- **Create and switch to a new branch**:
  ```bash
  git switch --create new-branch
  ```
- **Track a remote branch while creating a local branch**:
  ```bash
  git switch --create my-branch --track origin/my-branch
  ```

### 2. **Restoring Files with `git restore`**

- **Restore a file from the index to the working tree**:
  ```bash
  git restore myfile.txt
  ```
- **Restore a file from a specific commit**:
  ```bash
  git restore --source HEAD~3 -- myfile.txt
  ```
- **Restore changes to both the working tree and the index**:
  ```bash
  git restore --source HEAD~3 --staged --worktree myfile.txt
  ```

---

## 🔄 Migrating from `git checkout` to `git switch` and `git restore`

Here is a comparison of `git checkout` and the new commands:

| Task                          | Old Command (`git checkout`)        | New Command (`git switch` / `git restore`) |
| ----------------------------- | ----------------------------------- | ------------------------------------------ |
| Switch branches               | `git checkout my-branch`            | `git switch my-branch`                     |
| Create and switch to a branch | `git checkout -b new-branch`        | `git switch -c new-branch`                 |
| Restore a file                | `git checkout -- myfile.txt`        | `git restore myfile.txt`                   |
| Restore a file from a commit  | `git checkout HEAD~3 -- myfile.txt` | `git restore --source HEAD~3 myfile.txt`   |

## 🔗 References

- [GitHub Blog: Highlights from Git 2.23](https://github.blog/2019-08-16-highlights-from-git-2-23/)
- [Git 2.23 Release Notes](https://github.com/git/git/blob/master/Documentation/RelNotes/2.23.0.txt)
