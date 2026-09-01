# frozen_string_literal: true

#-- copyright
# OpenProject is an open source project management software.
# Copyright (C) the OpenProject GmbH
#
# SET4NPL modifications Copyright (C) 2026 SET4NPL contributors.
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# See COPYRIGHT and LICENSE files for more details.
#++

require "set"

module OpenProject
  module Set4npl
    module Features
      ENVIRONMENT_VARIABLE = "OPENPROJECT_SET4NPL_FEATURES"

      DEFAULT = Set.new(
        %i[
          baseline_comparison
          capture_external_links
          define_custom_style
          gantt_pdf_export
          mcp_server
          placeholder_users
          time_entry_time_restrictions
          work_package_query_relation_columns
          work_package_subject_generation
        ]
      ).freeze

      module_function

      def enabled?(feature)
        enabled.include?(feature.to_sym)
      end

      def enabled
        configured = ENV.fetch(ENVIRONMENT_VARIABLE, "all").strip.downcase

        return DEFAULT if configured.empty? || configured == "all"
        return Set.new.freeze if %w[none false 0].include?(configured)

        selected = configured.split(",").map { it.strip.to_sym }.to_set
        unknown = selected - DEFAULT

        if unknown.any?
          raise ArgumentError,
                "Unknown SET4NPL features in #{ENVIRONMENT_VARIABLE}: #{unknown.to_a.sort.join(', ')}"
        end

        selected.freeze
      end
    end
  end
end
