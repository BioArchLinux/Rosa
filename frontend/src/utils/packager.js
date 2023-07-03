const rePackagerField = /\(on behalf of (?<packager>.*)\)/
const reMailField = /<(?<email>.*)>/

/**
 * generate <a> HTML code for email address
 * @param {String} address email address
 * @returns {String} HTML code
 */
function generateMailtoAnchor (name, address) {
  return `<a href="mailto:${address}">${name}</a>`
}

/**
 * format packager field
 * @param {String} desc packager field in string
 * @returns {String} rendered HTML code
 */
export function formatPackager (desc) {
  if (desc === undefined) { return }
  const packager = rePackagerField.exec(desc).groups.packager
  const mailAddress = reMailField.exec(desc).groups.email

  return generateMailtoAnchor(packager, mailAddress)
}
