class NoteController < ApplicationController
   def list
      @notes = Note.find(:all, :order => 'modification_time DESC')
   end
end
