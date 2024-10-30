
# Fontconfig Edit Modes Behavior

This document describes how the `<edit>` tag in Fontconfig behaves depending on the `mode` attribute. These modes dictate how the font family list is modified during the font matching process.

---

## Example Scenario
- **Requested Font Family**: `["CustomFont"]`
  - `CustomFont` is not available on the system.
- **Rule Setup**: `<edit>` is used to add or modify the font family list.

---

### 1. **`append_last` (Add to the End)**
```xml
<edit name="family" mode="append_last"><string>sans-serif</string></edit>
```
- **Behavior**:
  - Adds `sans-serif` to the **end** of the existing font family list.
- **Result**:
  - Before: `["CustomFont"]`
  - After: `["CustomFont", "sans-serif"]`
- **Font Matching**:
  1. System searches for `CustomFont`.
  2. If not found, falls back to `sans-serif`.

---

### 2. **`prepend` (Add to the Beginning)**
```xml
<edit name="family" mode="prepend"><string>sans-serif</string></edit>
```
- **Behavior**:
  - Adds `sans-serif` to the **beginning** of the font family list.
- **Result**:
  - Before: `["CustomFont"]`
  - After: `["sans-serif", "CustomFont"]`
- **Font Matching**:
  1. System uses `sans-serif` first.
  2. Ignores `CustomFont` if `sans-serif` is available.

---

### 3. **`assign` (Replace Entire List)**
```xml
<edit name="family" mode="assign"><string>sans-serif</string></edit>
```
- **Behavior**:
  - Replaces the entire font family list with `sans-serif`.
- **Result**:
  - Before: `["CustomFont"]`
  - After: `["sans-serif"]`
- **Font Matching**:
  - Always uses `sans-serif`, completely ignoring `CustomFont`.

---

### 4. **`delete` (Remove a Specific Font)**
```xml
<edit name="family" mode="delete"><string>CustomFont</string></edit>
```
- **Behavior**:
  - Removes `CustomFont` from the font family list.
- **Result**:
  - Before: `["CustomFont"]`
  - After: `[]` (empty list).
- **Font Matching**:
  - Falls back to the system's default font settings.

---

### 5. **`append` (Add to the End Flexibly)**
```xml
<edit name="family" mode="append"><string>sans-serif</string></edit>
```
- **Behavior**:
  - Adds `sans-serif` to the **end** of the list but may adjust the position based on conditions.
- **Result**:
  - Before: `["CustomFont"]`
  - After: `["CustomFont", "sans-serif"]` or adjusted based on other factors.
- **Font Matching**:
  - Similar to `append_last`, with more flexibility.

---

### Comparison Table

| **Mode**         | **Behavior**                          | **Modified List Example**      | **Font Matching**                          |
|-------------------|---------------------------------------|---------------------------------|--------------------------------------------|
| `append_last`     | Add to the end of the list            | `["CustomFont", "sans-serif"]` | Tries `CustomFont`, then falls back.       |
| `prepend`         | Add to the beginning of the list      | `["sans-serif", "CustomFont"]` | Prioritizes `sans-serif`.                  |
| `assign`          | Replace the list entirely             | `["sans-serif"]`               | Always uses `sans-serif`.                  |
| `delete`          | Remove a specific font               | `[]` or partially modified list | Relies on default font settings if empty.  |
| `append`          | Add to the end flexibly              | `["CustomFont", "sans-serif"]` | Similar to `append_last`.                  |

---

## Summary
- **`append_last`**: Adds at the end, ensuring the fallback font is available.
- **`prepend`**: Adds at the beginning, prioritizing the new font.
- **`assign`**: Replaces the requested font entirely.
- **`delete`**: Removes the specified font family.
- **`append`**: Similar to `append_last` but allows more flexible placement.

These modes allow precise control over font matching and fallback behavior, ensuring predictable results in various scenarios.
