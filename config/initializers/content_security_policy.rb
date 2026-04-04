# Be sure to restart your server when you modify this file.

Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self
    policy.font_src    :self, :data
    policy.img_src     :self, :data
    policy.object_src  :none
    policy.script_src  :self, :unsafe_inline
    policy.style_src   :self, :unsafe_inline
    policy.connect_src :self

    if Rails.env.development?
      policy.connect_src :self, "ws://localhost:3035", "http://localhost:3035"
      policy.script_src  :self, :unsafe_inline, :unsafe_eval
    end
  end

  # Reporting only — not enforced until Phase 8 security hardening.
  config.content_security_policy_report_only = true
end
