#!/bin/bash

cat > ./backend.tf << EOF
terraform {
    backend "local" {
        path = "./cloud-setup-terraform-state.tfstate"
    }
}
EOF

echo "Project bootstrap is done!"
