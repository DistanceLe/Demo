defineClass("ViewController", {
    click: function(sender) {
            
        self.setIndex(self.index() + 2);
        var text = (self.index() + "");
        sender.setTitle_forState(text, 0);
    }
}, {});
