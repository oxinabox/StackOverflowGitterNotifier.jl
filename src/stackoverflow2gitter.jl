using Requests
using LightXML


const TAGNAME = "julia-lang"
const GITTER_WEBHOOK_URL = URI(ARGS[1]) #Don't go verion controlling the webook URL, that is onlt secure by obscurity.
const CHECK_INTERVAL = 60 #seconds
last_checked = now() - Dates.Hour(48)

immutable Question
    title::String
    url :: URI
    published :: DateTime
end

function Question(entry::XMLElement)
    Question(
         content(find_element(entry, "title")),
         URI(content(find_element(entry, "id"))),
         DateTime(content(find_element(entry, "published")), "yyyy-mm-ddTHH:MM:SSZ")
    )
end

function get_questions()
    feed_req = Requests.get("http://stackoverflow.com/feeds/tag"; query = Dict("tagnames" =>TAGNAME, "sort"=>"newest"))
    
    @assert(statuscode(feed_req)==200)
    feed_xml = parse_string(readall(feed_req))
    xroot = root(feed_xml)
    question_elements = get_elements_by_tagname(xroot, "entry")

    map(Question, question_elements)
end

function get_new_questions!()
    global last_checked
    questions = filter(pp -> pp.published > last_checked, get_questions())
    if length(questions) > 0
        last_checked =  maximum([pp.published for pp in questions]) #Use the most resent question as the one to look for questions after
    end

    questions
end


function send_gitter_activity(message::String)
    println("Sending: ", message)
    post(GITTER_WEBHOOK_URL; data = Dict("message" => message))
end

function format_question(question::Question)
    "SO: [$(question.title)]($(question.url))"
end

function send_gitter_question(question::Question)
    send_gitter_activity(format_question(question))
end

function send_new_questions!()
    map(send_gitter_question,  get_new_questions!())
end

#########################
# Main Loop: just keep checkind sending for ever
#

while(true)
    send_new_questions!()
    sleep(CHECK_INTERVAL)
end
