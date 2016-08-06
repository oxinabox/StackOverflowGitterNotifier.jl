# GitterBots.jl
GitterBots I've made for Julia. Currently just a bot that puts questions on StackOverflow into the sidebar


Run with

```
julia src/stackoverflow2gitter.jl  SO http://www.stackoverflow.com julia-lang https://webhooks.gitter.im/e/a9a6a5f25..

```

 - 1st arg is the Prefix, which is shown in the activity bar
 - 2nd is the site to query, anything for the stack exchange network should work
 - 3rd is that tag to track
 - 4th is the Webhook URL you get from the Gitter, Notifications -> Custom integration.
Note that to get/create this URL you need to be a admin for the Gitter Channel

Run the script using cron, or a similar schedualler.


<br/><br/><br/><br/><br/>
### Demo Screenshot

[![Demo](http://i.stack.imgur.com/WG7OL.png)](http://i.stack.imgur.com/WG7OL.png)
