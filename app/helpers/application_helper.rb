module ApplicationHelper

  def title
    unless title = @title
      namespace = %w(sessions registrations passwords).include?(controller_name) ? "devise.#{controller_name}" : controller_name
      title = t("#{namespace}.#{action_name}.title")
    end
    "Joblr | #{title}"
  end

  def subdomain?
    request.subdomain.present? && request.subdomain != 'www' && !request.host.match(/^staging.joblr.co|joblr.herokuapp.com|joblr-staging.herokuapp.com$/)
  end

  def multi_level_subdomain?
    request.subdomain.present? && request.subdomains.size == 2 && request.host.match(/^[^\.]+\.(staging.joblr.co|joblr.herokuapp.com|joblr-staging.herokuapp.com)$/)
  end

  def signed_up?(user)
    user && !user.profiles.empty? && user.profile.persisted?
  end

  # Errors
  # ------

  def error_messages(object, options = {})
    errors = unduplicated_errors(object, options).map! do |attribute, message|
      "#{object.class.human_attribute_name(attribute).downcase} #{message}"
    end.to_sentence
    "#{t('flash.error.base')} #{errors}."
  end

  def unduplicated_errors(object, options = {})
    object.errors.select do |attribute, message|
      options[:only] ? options[:only].include?(attribute) && message == object.errors[attribute].first : message == object.errors[attribute].first
    end
  end

  # Analytics
  # ---------

  def kiss_init
    content_tag(:script, :type => 'text/javascript') do
      "var _kmq = _kmq || [];
      var _kmk = _kmk || 'e8e98ddeeceb420cd63d5953d02ac7558550011a';
      function _kms(u){
        setTimeout(function(){
          var d = document, f = d.getElementsByTagName('script')[0],
          s = d.createElement('script');
          s.type = 'text/javascript'; s.async = true; s.src = u;
          f.parentNode.insertBefore(s, f);
        }, 1);
      }
      _kms('//i.kissmetrics.com/i.js');
      _kms('//doug1izaerwt3.cloudfront.net/' + _kmk + '.1.js');"
    end
  end

  def kiss_event(type, value, options = {})
    content_tag(:script, :type => 'text/javascript') do
      "_kmq.push([#{type}, #{value}, #{options}]);"
    end
  end
end
