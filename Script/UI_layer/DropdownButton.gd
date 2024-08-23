extends OptionButton


func _ready():
	for i in range(6):
		add_item(str(i), i)
#    connect("item_selected", self, "_on_OptionButton_item_selected")
#
#func _on_OptionButton_item_selected(id):
#    print("Selected option: " + str(id))
