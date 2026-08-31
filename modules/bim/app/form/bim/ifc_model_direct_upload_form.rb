# frozen_string_literal: true

#-- copyright
# OpenProject is an open source project management software.
# Copyright (C) the OpenProject GmbH
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2013 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
#
# See COPYRIGHT and LICENSE files for more details.
#++

module Bim
  class IfcModelDirectUploadForm < ApplicationForm
    form do |f|
      @form_data.each do |key, value|
        f.html_content do
          content_tag(:input, nil, type: :hidden, name: key, value:)
        end
      end

      f.group do |group|
        group.html_content do
          content_tag(:label,
                      Bim::IfcModels::IfcModel.human_attribute_name(:ifc_attachment),
                      for: "ifc_model_direct_upload_file_input")
        end
        group.html_content do
          content_tag(:div, class: "FormControl-input-wrap") do
            content_tag(:input, nil, id: "ifc_model_direct_upload_file_input", type: :file, name: "file", accept: ".ifc")
          end
        end
      end

      f.text_field(
        name: :ifc_attachment,
        input_html: { name: "file" },
        type: :file,
        label: Bim::IfcModels::IfcModel.human_attribute_name(:ifc_attachment),
        border: 0,
        accept: ".ifc",
        input_width: :medium,
        required: true
      )
      f.check_box(name: :is_default, label: Bim::IfcModels::IfcModel.human_attribute_name(:is_default))
      f.submit(name: :save, label: I18n.t(:button_create), scheme: :primary)
    end

    def initialize(form_data:)
      super()
      @form_data = form_data
    end
  end
end
