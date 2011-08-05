module UsersHelper
  def avatar_for(user, size = 48)
    default_url = "#{root_url}assets/guest.jpg"
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    image_tag "http://gravatar.com/avatar/#{gravatar_id}.png
                ?s=#{size}&d=#{CGI.escape(default_url)}",
                size: "#{size}x#{size}"
  end
end
