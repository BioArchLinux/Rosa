export function calculateSize(size) {
  function wellSized(num) {
    return num > 1 && num < 1024
  }
  if (size === undefined) { return }
  if (wellSized(size)) { return `${size.toFixed(1)}  B` }
  size /= 1024
  if (wellSized(size)) { return `${size.toFixed(1)} KB` }
  size /= 1024
  if (wellSized(size)) { return `${size.toFixed(1)} MB` }
  size /= 1024
  if (wellSized(size)) { return `${size.toFixed(1)} GB` }
  console.error('size too big')
}
