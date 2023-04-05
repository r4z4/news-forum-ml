# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     NewsForum.Repo.insert!(%NewsForum.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias NewsForum.Repo
import Ecto.UUID
alias NewsForum.Accounts.User
alias NewsForum.Forum.Post
alias NewsForum.Forum.Article

Repo.insert_all(User, [
      %{id: "a9f44567-e031-44f1-aae6-972d7aabbb45", username: "admin", email: "admin@admin.com", hashed_password: Bcrypt.hash_pwd_salt("password"), confirmed_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{username: "jim_the_og", email: "jim@jim.com", hashed_password: Bcrypt.hash_pwd_salt("password"), confirmed_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{username: "aaron", email: "aaron@aaron.com", hashed_password: Bcrypt.hash_pwd_salt("password"), confirmed_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{username: "r_boyd", email: "User1@example.com", hashed_password: Bcrypt.hash_pwd_salt("password"), confirmed_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{username: "TheMan98", email: "User2@example.com", hashed_password: Bcrypt.hash_pwd_salt("password"), confirmed_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{username: "Anders01", email: "User3@example.com", hashed_password: Bcrypt.hash_pwd_salt("password"), confirmed_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{username: "j_trumpet", email: "User4@example.com", hashed_password: Bcrypt.hash_pwd_salt("password"), confirmed_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{username: "JudFrazier", email: "User5@example.com", hashed_password: Bcrypt.hash_pwd_salt("password"), confirmed_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{username: "MMMM0101", email: "User6@example.com", hashed_password: Bcrypt.hash_pwd_salt("password"), confirmed_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{username: "BigBadRoy", email: "User7@example.com", hashed_password: Bcrypt.hash_pwd_salt("password"), confirmed_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{username: "tatTay33", email: "User8@example.com", hashed_password: Bcrypt.hash_pwd_salt("password"), confirmed_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{username: "r_r_lays", email: "User9@example.com", hashed_password: Bcrypt.hash_pwd_salt("password"), confirmed_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{username: "redman6", email: "redman@example.com", hashed_password: Bcrypt.hash_pwd_salt("password"), confirmed_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{username: "Howitzaaah", email: "bbr@example.com", hashed_password: Bcrypt.hash_pwd_salt("password"), confirmed_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{username: "temp09tem", email: "t89t@example.com", hashed_password: Bcrypt.hash_pwd_salt("password"), confirmed_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()}
])
# Removing IDs but will need them for prod likely (binary_id vs. int)
Repo.insert_all(Post, [
      %{title: "First Post", content: "This is my first post here. It sure is nice to meet everyone and joine a great community :)", date: NaiveDateTime.local_now(), author: "a9f44567-e031-44f1-aae6-972d7aabbb45", category: "news", inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{title: "Need Some Help Here", content: "Does anyone know where I can find a good solution for this one problem that I have?", date: NaiveDateTime.local_now(), author: "a9f44567-e031-44f1-aae6-972d7aabbb45", category: "news", inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{title: "The Beret", content: "This morning I woke up and decided I was going to wear a beret. Today is the day.", date: NaiveDateTime.local_now(), author: "a9f44567-e031-44f1-aae6-972d7aabbb45", category: "entertainment", inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{title: "2nd Post", content: "Hey look, it is post #2 for me. Still liking it here.", date: NaiveDateTime.local_now(), author: "a9f44567-e031-44f1-aae6-972d7aabbb45",  category: "news", inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{title: "First Post", content: "Blouse!", date: NaiveDateTime.local_now(), author: "a9f44567-e031-44f1-aae6-972d7aabbb45", category: "news", inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{title: "Tell Me ...", content: "Who is your favorite band for anyone there who would like to answer?", date: NaiveDateTime.local_now(), author: "a9f44567-e031-44f1-aae6-972d7aabbb45", category: "sports", inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{title: "Like?", content: "Well this is pretty cool to be able to see that everyone here is liking the posts", date: NaiveDateTime.local_now(), author: "a9f44567-e031-44f1-aae6-972d7aabbb45",  category: "news", inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{title: "Private Post", content: "This is a private post so I wonder who will be able to see this one?", date: NaiveDateTime.local_now(), author: "a9f44567-e031-44f1-aae6-972d7aabbb45", category: "sports", inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()}
])

Repo.insert_all(Article, [
      %{title: "Washington State Stockpiles Abortion Pill", content: "Washington state officials have stocked up on a key abortion drug in preparation for the possibility that it could become much more difficult to access nationwide, pending the outcome of a federal 
                        lawsuit brought by anti-abortion-rights groups. Gov. Jay Inslee, a Democrat, says he ordered the Washington Department of Corrections to use its pharmacy license to buy 30,000 doses of mifepristone, an estimated three-year supply for patients in 
                        Washington state. The pills were received on March 31. Inslee says the University of Washington has obtained an additional 10,000 doses, or about enough for a fourth year. Noting that Washington is the first state to take such an action, Inslee 
                        called the purchase 'an insurance policy' in case the drug becomes unavailable.", desc: "New York Times", date: NaiveDateTime.local_now(), author: "a9f44567-e031-44f1-aae6-972d7aabbb45", category: "news", inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{title: "UCLA Still Number One", content: "Connecticut closes the book on one of the most dominant NCAA tournament runs in recent memory with the well-earned No. 1 ranking in the final USA TODAY Sports men's basketball coaches poll.The Huskies 
                        claim all 32 first-place votes after concluding their title run with another double-digit victory against San Diego State in the championship game. San Diego State does finish second, though it was far from unanimous as the voting reflected
                        a wide variety of perspectives following such a wild and unpredictable tournament that saw three teams reach the Final Four for the first time.", desc: "Chicago Tribune", date: NaiveDateTime.local_now(), author: "a9f44567-e031-44f1-aae6-972d7aabbb45", category: "sports",
                        inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()},
      %{title: "Susanna Hoffs' 'This Bird Has Flown' is a love story — and a valentine to music", content: "Jane Start's life is all over the place. The musician was once a star, albeit a brief one — she scored a hit single with 'Can't You See I Want You,'' a cover 
                        of a song by a pop star. But in the 10 years since then, our hero has taken a fall: 'I was living with my parents, which at thirty-three was demoralizing,' she says, bemoaning her life with all of her possessions in four garbage bags, sitting near 
                        her 'sagging twin bed.' Jane is the charming, funny, but unlucky protagonist of This Bird Has Flown, the novel from Susanna Hoffs, the singer and guitarist who rose to fame with the Bangles in the 1980s. It's a smart romantic comedy that proves that 
                        Hoffs' immense writing talent isn't just confined to songs. As the novel opens, Jane is preparing for a gig in Las Vegas. She's not exactly thrilled to be playing a private party, but she chooses to look at the bright side: 'The pay tonight would 
                        mean a deposit on an apartment, and a few months' rent, a chance to make another artsy record, even if no one bothered to listen to it. It would matter to me. If I could ever write another song again, that is.'.", 
                        desc: "Reddit", date: NaiveDateTime.local_now(), author: "a9f44567-e031-44f1-aae6-972d7aabbb45", category: "entertainment", inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()}
])