#!/bin/sh
set -e

# Make sure the server folder exists
mkdir -p ${MOONLIGHT_WEB_PATH}/server

# Home Assistant strips the ingress prefix before forwarding requests. Derive it
# in the browser so API calls remain inside the ingress endpoint.
cat > ${MOONLIGHT_WEB_PATH}/static/config_.js <<'EOF'
import CONFIG from "./config.js";
export function buildUrl(path) {
    const configuredPrefix = CONFIG?.path_prefix;
    const ingressPrefix = window.location.pathname.match(/^\/api\/hassio_ingress\/[^/]+/)?.[0] ?? "";
    return `${window.location.origin}${configuredPrefix || ingressPrefix}${path}`;
}
EOF

# Run main application
exec ${MOONLIGHT_WEB_PATH}/web-server --path-prefix "" "$@"