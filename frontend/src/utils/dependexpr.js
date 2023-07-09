export function getTrueName(nameexpr) {
  return /^[\w\d\-]+/.exec(nameexpr)[0]
}
