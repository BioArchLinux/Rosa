const reMailField = /<(?<email>.*)>/

function generateMailtoAnchor (address) {
  return `<a href="mailto:${address}">${address}</a>`
}

/**
 * replace range of string with another string
 * "... [index+length] ..." -> "... replacement ..."
 * @param {Number} start start position of range
 * @param {Number} length length of range
 * @param {String} replacement replacement string
 * @returns {String} Result
 */
function replaceRange (start, length, replacement) {
  return this.substr(0, start) + replacement + this.substr(start + length)
}

export function formatPackager (desc) {
  if (desc === undefined) { return }
  const mailMatch = reMailField.exec(desc)
  const htmlAnchor = generateMailtoAnchor(mailMatch.groups.email)
  return replaceRange.call(desc, mailMatch.index, mailMatch[0].length, `<${htmlAnchor}>`)
}
