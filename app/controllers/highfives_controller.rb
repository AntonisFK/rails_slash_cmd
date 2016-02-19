class HighfivesController < ApplicationController
  require "slack-notify"
  include ActionView::Helpers::TextHelper
  skip_before_action :verify_authenticity_token

  COMMAND_TOKEN = 'UnxhSF9YTMsF9dhaf30MHp7U'

  def receiver
  	@user ="d"
  	client = SlackNotify::Client.new(
	  webhook_url: "https://hooks.slack.com/services/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",
	  channel: "#sandbox",
	  username: "Kook Bot",
	  icon_url: "http://mydomain.com/myimage.png",
	  link_names: 1
	)
  	
    if params[:token] = COMMAND_TOKEN
      # Confirm token

      # Inspect params
		if params[:text] != ""
			resp_type = "in_channel"
			splitted = params[:text].split(" ")
			p 
	      	if splitted[0][0] == "@"
	      		user = splitted.slice!(0)
	      		unless User.find_by("name = ?", user)
	      			user_object = User.create(name: user)
	      		else
	      			user_object = User.find_by("name = ?", user)
	      		end
	      		splitted = splitted.join(" ")
	      		Hfive.create(content: splitted, user: user_object)
	      		client.notify("*You've been high-fived by #{params['user_name']}!* S/he said `'#{splitted}'`.", user)
	       		message = " *#{user}* `was high-fived by #{params['user_name']}`"
	       	elsif splitted[0] == "help"
	       		resp_type = "ephemeral"
	       		message = "Syntax is /high_five [user_name] [text]\n Example: `/high_five @example_user For being awesome!`\n" +
	       		"To check status type `/high_five`"
	      	end
	    else
	    	resp_type = "ephemeral"
	    	if user_object = User.find_by("name = ?", ("@" + params['user_name']))
		    	high_fives = Hfive.where("user_id = ?", user_object.id)
		    	hf_count = high_fives.count

		    	if hf_count > 0 and hf_count < 3
		    		picture = "https://media.giphy.com/media/gdNlcJ1tAtiSI/giphy.gif"
		    		hf_status = "rookie"
		    	elsif hf_count > 2 and hf_count < 6
		    		picture = "https://media.giphy.com/media/lcYFNTaz4U9jy/giphy.gif"
		    		hf_status = "ninja"
		    	elsif hf_count > 5
		    		picture = "https://media.giphy.com/media/d2Z0WixyRO9WyU6Y/giphy.gif"
		    		hf_status = "hacker"
		    	end
		    else
		    	picture = "https://media.giphy.com/media/rRZfOOKROFUqs/giphy.gif"
		    	hf_status = "noob"
		    end
		    five_var = pluralize(hf_count,'high five')
		    message = "You have gotten #{five_var}, you're a #{hf_status}!"
	    end

      p user 


      # Debug with byebug
      # byebug

      # Respond with random messag

      	response = {
        	response_type: resp_type,
        	text: message,
        	attachments: [
        		{
        		text: "",
          		image_url: picture
        		}
        	]
      	}

      	render json: response

    	else
      		respond :no_content
    end
  end 
end