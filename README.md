# bouncer
A tiny sinatra post request consuming tool.

It's nothing just consumes a request with:
```json
{
  "customer_id": "<customer_id>",
  "company_id": "<company_id>",
  "amount": "<amount>",
  "currency": "<currency>"
}
```

and responses:

```json
{
  "id": "<id>",
  "customer_id": "<customer_id>",
  "company_id": "<company_id>",
  "amount": "<amount>",
  "currency": "<currency>",
  "number": "<number>",
  "status": "<status>"
}
```

:p :p :p
### Installation

clone the repo: `git@github.com:mur-wtag/bouncer.git`

install gems: `bundle` (if bundler not available: `gem install bundler`)

### Usage
You can run the app with `ruby app.rb`, and open [http://localhost:4567](http://localhost:4567) to see the interface.

### Need to know
**Basic Authentication Credentials**

- username = 'bounce'

- password = 'pass'

**Available URLs**

1. `GET /`

2. `GET /ping`

3. `POST /voucher_eligible`


Thanks!