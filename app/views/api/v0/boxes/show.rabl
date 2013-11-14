# app/views/api/v0/boxes/show.rabl
object @box
attributes :id, :name, :description, :likes, :dislikes, :price_cents, :available_single, :available_weekly, :available_fortnightly, :available_monthly, :extras_limit, :exclusions_limit, :substitutions_limit ,:hidden 

unless @embed['available_extras'].nil?
	child :extras do
	  attributes :id, :name, :unit, :price_cents, :hidden
	end
end

unless @embed['images'].nil?
	node :images do
		@box_images
	end  
end


