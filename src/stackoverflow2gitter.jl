using Requests
using LightXML



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

"""
eg
siteurl = "http://stackoverflow.com"
tag = "julia-lang"
"""
function get_questions(siteurl, tag)
    siteuri = URI(siteurl * "/feeds/tag")
    feed_req = Requests.get(siteuri; query = Dict("tagnames" =>tag, "sort"=>"newest"))
    
    @assert(statuscode(feed_req)==200)
    feed_xml = parse_string(readall(feed_req))
    xroot = root(feed_xml)
    question_elements = get_elements_by_tagname(xroot, "entry")

    map(Question, question_elements)
end

function select_new_questions(questions, last_checked)
    questions = filter(pp -> pp.published > last_checked, questions)
    if length(questions) > 0
        last_checked =  maximum([pp.published for pp in questions]) #Use the most resent question as the one to look for questions after
    	println("updated last_checked: $(last_checked)")
    end

    questions, last_checked
end


function send_gitter_activity(webhook_url, message::String, level = "info")
    println("Sending: ", message)
    post(webhook_url; data = Dict("message" => message, "level" => level))
end

function format_question(question::Question, prefix="")
    "$(prefix): [$(question.title)]($(question.url))"
end

function send_gitter_question(webhook_url, question::Question, prefix)
    send_gitter_activity(webhook_url, format_question(question, prefix))
end


LASTCHECKED_FILENAME_SUFFIX = "_lastchecked.jsz"
function load_last_checked(prefix)
	try
		open(prefix*LASTCHECKED_FILENAME_SUFFIX, "r") do fp
			deserialize(fp)
		end
	catch ee
		warn("Failed to load Last checked. Defaulting: $ee")
		now() - Dates.Hour(24) 
	end
end

function save_last_checked(prefix, last_checked)
	open(prefix*LASTCHECKED_FILENAME_SUFFIX, "w") do fp
		serialize(fp, last_checked)
	end
	println("Updated $prefix last check to $last_checked")
end


function main(prefix::String, siteurl::String, tag::String, gitter_webhook_url::URI)
	last_checked = load_last_checked(prefix)
	all_questions = get_questions(siteurl, tag)
	new_questions, new_last_checked = select_new_questions(all_questions, last_checked)

	
	for question in new_questions
		send_gitter_question(gitter_webhook_url, question, prefix)
	end
	
	save_last_checked(prefix, new_last_checked)
end

main(ARGS[1], ARGS[2], ARGS[3], URI(ARGS[4]))


