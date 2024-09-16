# frozen_string_literal: true

Rails.application.config.after_initialize do
  if Spree::Core::Engine.backend_available?
    Rails.application.config.spree_backend.tabs[:product].add(SpreeProductVideos::Admin::Tabs::ProductTabsBuilder.new.build)
  end
end
