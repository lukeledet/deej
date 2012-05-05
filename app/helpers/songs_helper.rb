module SongsHelper
  def format_time seconds
    minutes, seconds = seconds.divmod 60
    hours, minutes = minutes.divmod 60

    just = ->(x) {x.to_s.rjust 2, '0'}

    if hours > 0
      "#{hours}:#{just[minutes]}:#{just[seconds]}"
    else
      "#{minutes}:#{just[seconds]}"
    end
  end
end
