defmodule CarpoolWeb.TripLive.ChatComponent do
  use CarpoolWeb, :live_component
  alias Carpool.Messages
  alias Carpool.Messages.Message

  def render(assigns) do
    ~H"""
    <div>
      <div id="myModal" class="modal">
        <div class="modal-content rounded-md pt-12 ">
          <div class="w-[100%]   overflow-hidden h-[70vh] flex flex-col">
            <div class="border-gray-200 border-b-2 rounded-t-xl bg-gray-100 shadow-gray-300 flex justify-between items-center  p-4   w-[100%]">
              <div class="flex gap-2 items-center">
                <div class=" w-[40px] bg-[#FECC18] rounded-full h-[40px]  "></div>
                <p class="text-[#3C3E3E] text-sm poppins-regular">
                  <p><%= @receiver.email %></p>
                </p>
              </div>

              <div class="flex text-white items-center gap-2"></div>
            </div>
            <div class="bg-gray-100 h-[80%] flex flex-col-reverse overflow-y-scroll  md:p-4 p-2  w-[100%]">
              <div class="flex flex-col w-[100%]   gap-2">
                <%= for chat <- @chats do %>
                  <%= if chat.sender_id != @user.id do %>
                    <div class="flex  justify-start   ">
                      <p class="   p-2 md:h-[70px] text-xs bg-white break-words text-black w-[200px]">
                        <%= chat.text %>
                      </p>
                    </div>
                  <% else %>
                    <div class="flex  justify-end   ">
                      <p class="  text-white p-2 md:h-[70px] break-words text-xs bg-[#3C3E3E]  w-[200px]">
                        <%= chat.text %>
                      </p>
                    </div>
                  <% end %>
                <% end %>
              </div>
            </div>

            <div class="bg-gray-100 rounded-b-xl border-gray-200 border-t-2  pb-8  p-4   w-[100%]">
              <.form let={f} for={@chat_changeset} id="message-form" phx-submit="save">
                <div class="flex justify-between  w-[100%] items-center">
                  <div class="md:w-[85%] w-[75%] text-black ">
                    <%= text_input(f, :text,
                      class:
                        "w-[100%] md:h-[90%] h-[50%]  border border-transparent   focus:ring-0 border-none  p-4 bg-white shadow-gray-300 shadow-md",
                      placeholder: "Enter message..."
                    ) %>
                  </div>

                  <div class="p-2 flex justify-center items-center hover:scale-105 transition-all duration-500 ease-in-out rounded-md bg-[#3C3E3E]">
                    <%= submit do %>
                      <%= Heroicons.icon("paper-airplane",
                        type: "solid",
                        class: "h-6 text-white w-6"
                      ) %>
                    <% end %>
                  </div>
                </div>
              </.form>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
