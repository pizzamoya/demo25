#!/bin/bash
if [ "$HOSTNAME" = isp ]; then
. ISP.sh
fi
if [ "$HOSTNAME" = hq-srv.au-team.irpo ]; then
. HQ-SRV.sh
fi
if [ "$HOSTNAME" = br-srv.au-team.irpo ]; then
. BR-SRV.sh
fi
if [ "$HOSTNAME" = hq-cli.au-team.irpo ]; then
. HQ-CLI.sh
fi
