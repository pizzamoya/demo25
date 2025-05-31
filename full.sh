#!/bin/bash
if [ "$HOSTNAME" = isp ]; then
. demo25/ISP.sh
echo "ISP"
fi
if [ "$HOSTNAME" = hq-srv.au-team.irpo ]; then
. demo25/HQ-SRV.sh
echo "HQ-SRV"
fi
if [ "$HOSTNAME" = br-srv.au-team.irpo ]; then
. demo25/BR-SRV.sh
echo "BR-SRV"
fi
if [ "$HOSTNAME" = hq-cli.au-team.irpo ]; then
. demo25/CLI.sh
echo "HQ-CLI"
fi
