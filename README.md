# tails.com's dbt-tableau-wrangler Package

Used in conjunction with our [tails-tableau-wrangler](https://github.com/tailsdotcom/tails-tableau-wrangler)
[singer tap](https://www.singer.io/), this package helps to manage Tableau Server.

In particular, [tails-tableau-wrangler](https://github.com/tailsdotcom/tails-tableau-wrangler)
extracts attributes embedded inside Workbook files that are otherwise difficult
to introspect, allowing us to answer questions such as:

- Which Workbooks depend on which tables in which databases?
- How many Workbooks depend on Excel, CSV or Google Sheets?
- Who's credentials are used for embedded connections, in which Workbooks?

But wait, **there's more**! `tails-tableau-wrangler` also uses the excellent
[SQLFluff](https://github.com/sqlfluff/sqlfluff) to _extract table references_
from embedded Custom SQL text buried deep inside Workbooks 🎉 In conjunction
with [dbt_artifacts](https://hub.getdbt.com/tailsdotcom/dbt_artifacts/latest/)
we are thus able to compare the references in Tableau with models in our dbt
project, answering additional questions such as:

- Which Workbooks reference what models?
- Which workbooks reference models (tables) that no longer exist in our warehouse?

These last two answers have been invaluable during our recent dbt remodel,
allowing us to proactively update Workbooks as old models are deprecated and
removed 🚀

More entities from the Tableau Server API to follow, with PR's most welcome!
Watch this space 👀