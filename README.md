# GitterBots.jl
GitterBots I've made for Julia. Currently just a bot that puts questions on StackOverflow into the sidebar


Run with

```
julia src/stackoverflow2gitter.jl https://webhooks.gitter.im/e/a9a6a5f25...
```

where the URL at the end is the Webhook URL you get from the Gitter, Notifications -> Custom integration.
Note that to get/create this URL you need to be a admin for the Gitter Channel


This script runs forever, polling and posting questions every 60 seconds (by default -- config at top of file).
When first started it will post up to the last 30 questions from the last 48 hours.
It is currently set to key off the "julia-lang" tag.

<br/><br/><br/><br/><br/>
### Demo Screenshot

[![Demo](http://i.stack.imgur.com/WG7OL.png)](http://i.stack.imgur.com/WG7OL.png)
