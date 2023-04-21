# example/tfvars

region = "eu-west-1"

tags = {
  "Project"    = "example"
  "Owner"      = "example"
  "Billing_ID" = "000"
}
standard_os_baselines = {
  AMAZON_LINUX_2 = {
    is_default = false
    approval_rules = [
      {
        approve_after_days  = 30,
        compliance_level    = "CRITICAL",
        enable_non_security = true,
        patch_filters = [
          {
            key    = "CLASSIFICATION",
            values = ["*"]
          },
          {
            key    = "PRODUCT",
            values = ["*"]
          },
          {
            key    = "SEVERITY",
            values = ["Critical"]
          }
        ]
      },
      {
        approve_after_days  = 60,
        compliance_level    = "HIGH",
        enable_non_security = true,
        patch_filters = [
          {
            key    = "CLASSIFICATION",
            values = ["*"]
          },
          {
            key    = "PRODUCT",
            values = ["*"]
          },
          {
            key    = "SEVERITY",
            values = ["Important"]
          }
        ]
      },
      {
        approve_after_days  = 90,
        compliance_level    = "MEDIUM",
        enable_non_security = true,
        patch_filters = [
          {
            key    = "CLASSIFICATION",
            values = ["*"]
          },
          {
            key    = "PRODUCT",
            values = ["*"]
          },
          {
            key    = "SEVERITY",
            values = ["Medium"]
          }
        ]
      }
    ]
  }
  REDHAT_ENTERPRISE_LINUX = {
    is_default = false
    approval_rules = [
      {
        approve_after_days  = 30,
        compliance_level    = "CRITICAL",
        enable_non_security = true,
        patch_filters = [
          {
            key    = "CLASSIFICATION",
            values = ["*"]
          },
          {
            key    = "PRODUCT",
            values = ["*"]
          },
          {
            key    = "SEVERITY",
            values = ["Critical"]
          }
        ]
      },
      {
        approve_after_days  = 60,
        compliance_level    = "HIGH",
        enable_non_security = true,
        patch_filters = [
          {
            key    = "CLASSIFICATION",
            values = ["*"]
          },
          {
            key    = "PRODUCT",
            values = ["*"]
          },
          {
            key    = "SEVERITY",
            values = ["Important"]
          }
        ]
      },
      {
        approve_after_days  = 90,
        compliance_level    = "MEDIUM",
        enable_non_security = true,
        patch_filters = [
          {
            key    = "CLASSIFICATION",
            values = ["*"]
          },
          {
            key    = "PRODUCT",
            values = ["*"]
          },
          {
            key    = "SEVERITY",
            values = ["Moderate"]
          }
        ]
      }
    ]
  }
  WINDOWS = {
    is_default = false
    approval_rules = [
      {
        approve_after_days  = 30,
        compliance_level    = "CRITICAL",
        enable_non_security = false,
        patch_filters = [
          {
            key    = "CLASSIFICATION",
            values = ["*"]
          },
          {
            key    = "PRODUCT",
            values = ["*"]
          },
          {
            key    = "MSRC_SEVERITY",
            values = ["Critical"]
          }
        ]
      },
      {
        approve_after_days  = 60,
        compliance_level    = "HIGH",
        enable_non_security = false,
        patch_filters = [
          {
            key    = "CLASSIFICATION",
            values = ["*"]
          },
          {
            key    = "PRODUCT",
            values = ["*"]
          },
          {
            key    = "MSRC_SEVERITY",
            values = ["Important"]
          }
        ]
      },
      {
        approve_after_days  = 90,
        compliance_level    = "MEDIUM",
        enable_non_security = false,
        patch_filters = [
          {
            key    = "CLASSIFICATION",
            values = ["*"]
          },
          {
            key    = "PRODUCT",
            values = ["*"]
          },
          {
            key    = "MSRC_SEVERITY",
            values = ["Moderate"]
          }
        ]
      }
    ]
  }
}

critical_os_baselines = {
  AMAZON_LINUX_2 = {
    approval_rules = [
      {
        approve_after_days  = 0,
        compliance_level    = "CRITICAL",
        enable_non_security = true,
        patch_filters = [
          {
            key    = "CLASSIFICATION",
            values = ["*"]
          },
          {
            key    = "PRODUCT",
            values = ["*"]
          },
          {
            key    = "SEVERITY",
            values = ["Critical"]
          }
        ]
      }
    ]
  }
  REDHAT_ENTERPRISE_LINUX = {
    approval_rules = [
      {
        approve_after_days  = 0,
        compliance_level    = "CRITICAL",
        enable_non_security = true,
        patch_filters = [
          {
            key    = "CLASSIFICATION",
            values = ["*"]
          },
          {
            key    = "PRODUCT",
            values = ["*"]
          },
          {
            key    = "SEVERITY",
            values = ["Critical"]
          }
        ]
      }
    ]
  }
  WINDOWS = {
    approval_rules = [
      {
        approve_after_days  = 0,
        compliance_level    = "CRITICAL",
        enable_non_security = false,
        patch_filters = [
          {
            key    = "CLASSIFICATION",
            values = ["*"]
          },
          {
            key    = "PRODUCT",
            values = ["*"]
          },
          {
            key    = "MSRC_SEVERITY",
            values = ["Critical"]
          }
        ]
      }
    ]
  }
}

days = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
windows = ["Morning", "Afternoon", "Evening", "Night"]

maintenance_windows = {
  sun_morning = {
    patch_day = "SUN"
    patch_window = "Morning"
  }
  sun_afternoon = {
    patch_day = "SUN"
    patch_window = "Afternoon"
  }
  sun_evening = {
    patch_day = "SUN"
    patch_window = "Evening"
  }
  sun_night = {
    patch_day = "SUN"
    patch_window = "Night"
  }
}