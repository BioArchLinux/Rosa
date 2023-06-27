export
async function requestPackageList () {
  return await (await fetch(`${__API_BASE__}/api/pkglist.json`)).json()
}

export
async function requestPackageInfo (pkg) {
  return await (await fetch(`${__API_BASE__}/api/${pkg}.json`)).json()
}
