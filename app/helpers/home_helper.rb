module HomeHelper
	def uptime(created_at)
	  now = Time.current
	  difference = now - created_at

	  if difference < 1.day
	    return "#{(difference / 1.hour).round} horas"
	  elsif difference < 1.week
	    return "#{(difference / 1.day).round} dias"
	  elsif difference < 1.month
	    days = (difference / 1.day).to_i
	    weeks = (days / 7).to_i
	    remaining_days = days % 7
	    return "#{weeks} semana(s) e #{remaining_days} dia(s)"
	  elsif difference < 1.year
	    months = (difference / 1.month).to_i
	    remaining_days = (difference % 1.month) / 1.day
	    return "#{months} mês(es) e #{remaining_days.round} dia(s)"
	  else
	    years = (difference / 1.year).to_i
	    remaining_months = ((difference % 1.year) / 1.month).to_i
	    return "#{years} ano(s) e #{remaining_months} mês(es)"
	  end
	end
end
