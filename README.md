# DigitalOcean API

## Status

This API is a mostly-complete, mostly-untested, mostly literal implementation of the [DigitalOcean V2 API](https://developers.digitalocean.com/documentation/v2/).

It could probably be made more compact with some application of protocols and generics, and may be in the future.

## Unsupported

The follow API elements are as-of-yet unsupported, but are coming in a future version.

* Links object
* Meta object
* Rate-limit headers
* Droplet > BackupWindow object (missing from documentation)
* Droplet > CreateMultiple
* Droplet > Neighbor queries
* Droplet Actions > Requests by tag

## Example use

```
import Foundation
import DOAPI

// Intitialize

DigitalOcean.initialize(apiToken: <YOUR-API-TOKEN-HERE>)

// Fetch account

let acc = DOAccount.Get()

DigitalOcean.shared.request(request: acc) { success, result, error in
    guard success else { return }
    let account = result!.account
    print("Fetched account: \(result!.account.email)")
}

// List droplets

let request = DODroplet.List()

DigitalOcean.shared.request(request: request) { success, result, error in
    guard success else { return }
    let droplets = result!.droplets
    print("Found \(droplets.count) droplets")
    for droplet in droplets {
        print("\(droplet.name) : \(droplet.status)")
    }
}

RunLoop.current.run()
```
