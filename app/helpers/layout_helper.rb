# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper
  def title(page_title, show_title = true)
    content_for(:title) { h(page_title.to_s) }
    @show_title = show_title
  end

  def show_title?
    @show_title
  end

  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end

  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end

  FLASH_CLASSES = {notice: 'success', warning: 'warning', error: 'error'}

  def flash_bar(kind, message)
    classes = "alert-box #{FLASH_CLASSES[kind]}"
    message = message + link_to('&times;'.html_safe, '', class: 'close')
    content_tag(:div, message.html_safe, class: classes)
  end

  def checkmark_boolean(value)
    (value ? '&#x2714' : '&#10007').html_safe
  end

  def customer_title(customer, options = {})
    title_text = options.delete(:title) || customer_and_number(customer)
    title(title_text, false)

    return content_tag(:h1, customer_badge(customer, options), class: 'text-center')
  end

  def customer_and_number(customer)
    "##{customer.id} #{customer.name}"
  end

  def customer_badge(customer, options = {})
    content = ''

    if options[:link] == false
      content += content_tag(:span, "##{customer.id}", class: 'pill')
    elsif options.has_key?(:link)
      content += link_to("##{customer.id}", url_for(options[:link]), class: 'pill')
    else
      content += link_to("##{customer.id}", [customer.distributor, customer], class: 'pill')
    end

    customer_name = options[:customer_name] || customer.name
    content += content_tag(:span, customer_name, class: 'customer-name')

    content_tag(:span, content.html_safe, class: 'customer-badge')
  end
end
