const DATA_UNIT_FACTOR = 1024

export function calculateSize (size) {
  function wellSized (num) {
    return num > 1 && num < DATA_UNIT_FACTOR
  }
  if (size === undefined) { return }
  if (wellSized(size)) { return `${size.toFixed(1)}  B` }
  size /= DATA_UNIT_FACTOR
  if (wellSized(size)) { return `${size.toFixed(1)} KB` }
  size /= DATA_UNIT_FACTOR
  if (wellSized(size)) { return `${size.toFixed(1)} MB` }
  size /= DATA_UNIT_FACTOR
  if (wellSized(size)) { return `${size.toFixed(1)} GB` }
  console.error('size too big')
}
