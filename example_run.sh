#!/bin/sh
export GITTERWEBHOOK="https://webhooks.gitter.im/e/aaaadddb22232323a"
export SCRIPT="GitterBots.jl/src/stackoverflow2gitter.jl"
echo "----------------"
date
echo "---"

julia --depwarn=no $SCRIPT SO http://www.stackoverflow.com julia-lang $GITTERWEBHOOK;
julia --depwarn=no $SCRIPT CR http://codereview.stackexchange.com julia $GITTERWEBHOOK;
julia --depwarn=no $SCRIPT CV http://stats.stackexchange.com julia $GITTERWEBHOOK;
