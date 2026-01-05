SECURITY_RULES = [
    "No public IPs on production resources",
    "Avoid 0.0.0.0/0 in security groups",
    "Storage accounts must enable encryption",
    "Databases must not be publicly accessible"
]

BEST_PRACTICES = [
    "Use variables instead of hardcoded values",
    "All resources must have required tags",
    "Use for_each instead of count where possible",
    "Avoid deprecated Terraform resources"
]
