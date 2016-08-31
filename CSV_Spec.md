CSV Spec
--------

### Companies

Every company has 1 value for each of these fields: `id`, `name`. If you do not
have something for the `id` field, you can just use a serial number, i.e.
1,2,3...

Note: Company `id` and `name` for must*​* be unique.

Every company can have multiple domains mapped to it. The `domains` field should
be a comma separated list of domains that belong to the company.

Every company can have multiple custom fields. You should have one column per
custom field with the format:

-   `custom_fieldkey`

If the custom field is a `list` type, you should validate that values in the
source data exist within the list in Desk. If not, you either (1) need to map
the value to an existing value when building the export data or (2) add the
value to the list in Desk.

| **Column Name**   | **Field Description**                 | **Desk Field** | **Data Type**                                                                         | **Required** | **Unique** | **Validations**      | **Example 1**    | **Example 2**               |
|-------------------|---------------------------------------|----------------|---------------------------------------------------------------------------------------|--------------|------------|----------------------|------------------|-----------------------------|
| `id`              |                                       | `id`           | String                                                                                | True         | True       |                      | 8764387          | Q3867                       |
| `name`            |                                       | `name`         | String                                                                                | True         | True       |                      | Acme Inc.        |                             |
| `domains`         | Comma separated list of email domains | `domains`      | String                                                                                | False        | True       | Must be valid domain | domain.com       | domain.com, anotherone.net  |
| `custom_fieldkey` |                                       |                | String for List, Text. `DateTime`for Date. Float for Number. `Boolean`for True/False. | False        | False      |                      | custom\_industry | custom\_current\_sales\_rep |

 

### Customers

Every customer has 1 value for each of these fields: `id`, `first_name`,
`last_name`, `title` and `company_id`. If you do not have something for the `id`
field, you can just use a serial number, i.e. 1,2,3...

Every customer can have multiple values for `email` (10), `phone` (10),
`address` (5). To accommodate this, we have adopted the format as follows:

-   Emails - `email_home`, `email_work`, `email_mobile`, `email_other`

-   Phones - `phone_home`, `phone_work`, `phone_mobile`, `phone_other`

-   Addresses - `address_home`, `address_work`, `address_other`

Note: `email_*` and `id` must be unique.

You can use as many of each as needed. For example, if you have customers who
have 2 mobile phone numbers, its OK to have 2 columns named `phone_mobile`.

Every customer can have multiple custom fields. You should have one column per
custom field with the format:

-   `custom_fieldkey`

If the custom field is a `list` type, you should validate that values in the
source data exist within the list in Desk. If not, you either (1) need to map
the value to an existing value when building the export data or (2) add the
value to the list in Desk.

 

| **Column Name**   | **Field Description** | **Desk Field**  | **Data Type**                                                                         | **Required** | **Unique** | **Validations**                                                            | **Example 1**                        | **Example 2**                 |
|-------------------|-----------------------|-----------------|---------------------------------------------------------------------------------------|--------------|------------|----------------------------------------------------------------------------|--------------------------------------|-------------------------------|
| `id`              |                       | `id`            | String                                                                                | True         | True       |                                                                            | 8764387                              | Q3867                         |
| `first_name`      | Customer’s first      | `first_name`    | String                                                                                | False        | False      |                                                                            | Jon                                  |                               |
| `last_name`       |                       | `last_name`     | String                                                                                | False        | False      |                                                                            | Doe                                  |                               |
| `title`           |                       | `title`         | String                                                                                | False        | False      |                                                                            | Mr.                                  |                               |
| `company_id`      |                       | `company_id`    | String                                                                                | False        | False      | If value present, record with corresponding ID must exist in companies.csv | 655744                               |                               |
| `email_home`      |                       | `email_home`    | String                                                                                | False        | True       |                                                                            | jon.doe\@gmail.com                   |                               |
| `email_work`      |                       | `email_work`    | String                                                                                | False        | True       |                                                                            | jdoe\@work.com                       |                               |
| `email_mobile`    |                       | `email_mobile`  | String                                                                                | False        | True       |                                                                            |                                      |                               |
| `email_other`     |                       | `email_other`   | String                                                                                | False        | True       |                                                                            |                                      |                               |
| `phone_home`      |                       | `phone_home`    | String                                                                                | False        | False      |                                                                            | 123-123-1234                         | (789) 234-5432                |
| `phone_work`      |                       | `phone_work`    | String                                                                                | False        | False      |                                                                            |                                      |                               |
| `phone_mobile`    |                       | `phone_mobile`  | String                                                                                | False        | False      |                                                                            |                                      |                               |
| `phone_other`     |                       | `phone_other`   | String                                                                                | False        | False      |                                                                            |                                      |                               |
| `address_home`    |                       | `address_home`  | String                                                                                | False        | False      |                                                                            | 123 Main St, San Francisco, CA 94105 |                               |
| `address_work`    |                       | `address_work`  | String                                                                                | False        | False      |                                                                            |                                      |                               |
| `address_other`   |                       | `address_other` | String                                                                                | False        | False      |                                                                            |                                      |                               |
| `custom_fieldkey` |                       |                 | String for List, Text. `DateTime`for Date. Float for Number. `Boolean`for True/False. | False        | False      |                                                                            | custom\_location                     | custom\_security\_role\_admin |
