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

require "spec_helper"

RSpec.describe OpenProject::Set4npl::Features do
  describe ".enabled?" do
    it "enables the selected SET4NPL features" do
      expect(described_class::DEFAULT).to contain_exactly(
        :baseline_comparison,
        :capture_external_links,
        :define_custom_style,
        :gantt_pdf_export,
        :mcp_server,
        :placeholder_users,
        :time_entry_time_restrictions,
        :work_package_query_relation_columns,
        :work_package_sharing,
        :work_package_subject_generation
      )
    end

    it "enables all selected features by default",
       with_env: { "OPENPROJECT_SET4NPL_FEATURES" => "all" } do
      expect(described_class.enabled?(:mcp_server)).to be(true)
    end

    it "does not grant features outside the selected set",
       with_env: { "OPENPROJECT_SET4NPL_FEATURES" => "all" } do
      expect(described_class.enabled?(:portfolio_management)).to be(false)
    end

    it "accepts string feature names",
       with_env: { "OPENPROJECT_SET4NPL_FEATURES" => "mcp_server" } do
      expect(described_class.enabled?("mcp_server")).to be(true)
    end

    it "can disable every SET4NPL feature",
       with_env: { "OPENPROJECT_SET4NPL_FEATURES" => "none" } do
      expect(described_class.enabled?(:mcp_server)).to be(false)
    end

    it "rejects unknown feature names",
       with_env: { "OPENPROJECT_SET4NPL_FEATURES" => "mcp_server,unknown" } do
      expect { described_class.enabled }.to raise_error(ArgumentError, /unknown/)
    end
  end
end
