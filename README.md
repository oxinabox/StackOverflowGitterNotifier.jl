# StackOverflowGitterNotifier.jl

## Running

Run with

```
julia src/stackoverflow2gitter.jl  SO http://www.stackoverflow.com julia-lang https://webhooks.gitter.im/e/a9a6a5f25..

```

 - 1st arg is the Prefix, which is shown in the activity bar
 - 2nd is the site to query, anything for the stack exchange network should work
 - 3rd is that tag to track
 - 4th is the Webhook URL you get from the Gitter, Notifications -> Custom integration.
Note that to get/create this URL you need to be a admin for the Gitter Channel


Each time the script is run, it will push any new questions with the tag, to the gitter webhook URL.

Run the script using cron, or a similar schedualler, eg every 5 minutes

## Installation

 1. Install Julia (either v0.4 (old-stable), or v0.5 (stable)
 2. start the julia REPL by running `julia`
 3. install this package and it's dependencies by running `Pkg.clone("https://github.com/oxinabox/StackOverflowGitterNotifier.jl")` in the REPL
 4. Wait while the while the required HTTP libraries etc are downloaded and installed (you should see a running log)
 5. This repo should be installed into  `~/.julia/<vX.Y>/StackOverflowGitterNotifier.jl` where `<vX.Y>` is ether `v0.4` or `v0.5` depending on the julia versionm you are running.
 6. `cd` to that directory and run `bash example.sh` to check it is working, this should first compile some of the depencencies (if this is the first time running it), then give a warning that it `Failed to load Last checked.` (which is fine since there is no last checked date). Finally it should start listing questions it is sending to gitter -- don't worry these are not going anywhere as the example URL is bogus.
 7. Write yourself a cron script to run something like `example.sh` every 5 minutes or so -- using your webhook URL so it posts to your gitter. (see above section on running)

<br/><br/><br/><br/><br/>
### Demo Screenshot

[![Demo](http://i.stack.imgur.com/WG7OL.png)](http://i.stack.imgur.com/WG7OL.png)
