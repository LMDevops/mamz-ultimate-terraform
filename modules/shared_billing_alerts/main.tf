resource "google_billing_budget" "fifty" {
  billing_account = var.billing_account
  display_name    = "Alert for 50% budget spend"

  amount {
    specified_amount {
      currency_code = "USD"
      units         = var.budget
    }
  }

  threshold_rules {
    threshold_percent = 0.5
  }
}

resource "google_billing_budget" "seventyfive" {
  billing_account = var.billing_account
  display_name    = "Alert for 75% budget spend"

  amount {
    specified_amount {
      currency_code = "USD"
      units         = var.budget
    }
  }

  threshold_rules {
    threshold_percent = 0.75
  }
}

resource "google_billing_budget" "ninety" {
  billing_account = var.billing_account
  display_name    = "Alert for 90% budget spend"

  amount {
    specified_amount {
      currency_code = "USD"
      units         = var.budget
    }
  }

  threshold_rules {
    threshold_percent = 0.9
  }
}

resource "google_billing_budget" "ninetyfive" {
  billing_account = var.billing_account
  display_name    = "Alert for 95% budget spend"

  amount {
    specified_amount {
      currency_code = "USD"
      units         = var.budget
    }
  }

  threshold_rules {
    threshold_percent = 0.95
  }
}
