const API_PKGLIST = 'https://bioarchlinux.org/api/pkglist.json'

export
async function requestPackageList () {
  return await (await fetch('/api/pkglist.json')).json()
}

export
async function requestPackageInfo (pkg) {
  return await (await fetch(`/api/${pkg}.json`)).json()
}
