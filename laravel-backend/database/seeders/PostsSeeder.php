<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Post;
use App\Models\User;
use App\Models\School;
use Illuminate\Support\Str;

class PostsSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Get first user and school from database
        $user = User::first();
        $school = School::first();

        if (!$user || !$school) {
            $this->command->error('Please run the main DatabaseSeeder first to create users and schools.');
            return;
        }

        $samplePosts = [
            [
                'title' => 'University Announces New State-of-the-Art Research Laboratory',
                'excerpt' => 'The university unveils a cutting-edge research facility equipped with the latest technology to support groundbreaking scientific research.',
                'body' => '<p>In a momentous occasion for the academic community, the University has officially opened its new state-of-the-art research laboratory. This facility, which has been in development for the past two years, represents a significant investment in the future of scientific research and innovation.</p>

<p>The laboratory is equipped with cutting-edge technology, including advanced microscopy equipment, high-performance computing systems, and specialized instruments for various fields of study. The facility spans over 5,000 square meters and includes collaborative workspaces designed to foster interdisciplinary research.</p>

<p>"This new laboratory will enable our researchers to conduct groundbreaking studies that were previously impossible due to technological limitations," said the Vice-Chancellor during the opening ceremony. "We are committed to providing our faculty and students with the tools they need to push the boundaries of knowledge."</p>

<p>The facility will be accessible to undergraduate and postgraduate students, as well as faculty members across all departments. Special training sessions will be organized to familiarize users with the new equipment and safety protocols.</p>',
                'tags' => 'research,laboratory,science,innovation',
                'news_category_id' => 3, // Academic
                'featured' => true,
                'image_url' => 'https://images.unsplash.com/photo-1532094349884-543bc11b234d?w=800&h=600&fit=crop'
            ],
            [
                'title' => 'Annual Inter-Faculty Sports Competition Kicks Off This Weekend',
                'excerpt' => 'Students from all faculties will compete in various sporting events including football, basketball, athletics, and more.',
                'body' => '<p>The much-anticipated Annual Inter-Faculty Sports Competition is set to begin this weekend, promising three days of intense athletic competition and spirited camaraderie among students from all faculties.</p>

<p>This year\'s competition will feature 12 different sporting events, including football, basketball, volleyball, athletics, table tennis, and chess. Over 500 students have registered to participate, representing the highest turnout in the event\'s history.</p>

<p>The opening ceremony will take place on Saturday morning at the main sports complex, with the Dean of Students Affairs officiating. Each faculty will parade with their unique colors and mascots, creating a vibrant display of school spirit.</p>

<p>"The Inter-Faculty Sports Competition is more than just athletic competition; it\'s about building unity, fostering healthy competition, and creating lasting memories," said the Sports Director. "We encourage all students to come out and support their faculties."</p>

<p>Food vendors, entertainment, and live music will be available throughout the weekend. Admission is free for all students with valid ID cards.</p>',
                'tags' => 'sports,competition,faculty,athletics',
                'news_category_id' => 4, // Sports
                'featured' => true,
                'image_url' => 'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?w=800&h=600&fit=crop'
            ],
            [
                'title' => 'Registration Deadline Extended for New Academic Session',
                'excerpt' => 'The university administration has extended the registration deadline for the 2025/2026 academic session by two weeks.',
                'body' => '<p>In response to numerous requests from students and parents, the University Administration has announced a two-week extension of the registration deadline for the upcoming 2025/2026 academic session.</p>

<p>The new deadline, which was originally set for October 15th, has been moved to October 29th, 2025. This extension applies to both new and returning students across all levels and departments.</p>

<p>"We understand that some students are still facing challenges with documentation and financial arrangements," explained the Dean of Student Affairs. "This extension is designed to ensure that no student misses out on their education due to circumstances beyond their control."</p>

<p>Students are reminded that late registration fees will be waived for those who complete their registration by the new deadline. The online portal remains open 24/7, and help desks have been set up in various locations across campus to assist students who may encounter difficulties with the registration process.</p>

<p>For more information, students can contact the Registry Office or visit the university\'s student portal.</p>',
                'tags' => 'registration,deadline,academic,administration',
                'news_category_id' => 3, // Academic
                'featured' => false,
                'image_url' => 'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=800&h=600&fit=crop'
            ],
            [
                'title' => 'Guest Lecture: Nobel Laureate to Speak on Climate Change Solutions',
                'excerpt' => 'Renowned environmental scientist and Nobel Prize winner Dr. Sarah Johnson will deliver a keynote lecture on innovative solutions to climate change.',
                'body' => '<p>The university is honored to host Dr. Sarah Johnson, Nobel Prize laureate and renowned environmental scientist, who will deliver a special lecture on "Innovative Solutions to Climate Change: The Role of Technology and Policy."</p>

<p>The event is scheduled for Thursday, October 23rd at 2:00 PM in the Grand Auditorium. Dr. Johnson, who received the Nobel Prize in Environmental Sciences in 2023, has dedicated her career to researching sustainable solutions to environmental challenges.</p>

<p>"Dr. Johnson\'s work has inspired a generation of environmental scientists and policymakers," said the Dean of the Faculty of Science. "Her insights on combining technological innovation with effective policy frameworks have proven invaluable in addressing climate challenges."</p>

<p>The lecture will be followed by a Q&A session where students and faculty can engage directly with Dr. Johnson. The event is open to all members of the university community, but seating is limited, so early arrival is recommended.</p>

<p>This lecture is part of the university\'s Distinguished Speaker Series, which brings world-renowned experts to campus to share their knowledge and inspire the next generation of leaders.</p>',
                'tags' => 'lecture,climate change,nobel prize,environment',
                'news_category_id' => 1, // News
                'featured' => true,
                'image_url' => 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800&h=600&fit=crop'
            ],
            [
                'title' => 'Student Drama Club Presents "A Midsummer Night\'s Dream"',
                'excerpt' => 'The university\'s drama club will perform Shakespeare\'s classic comedy with a modern twist this weekend.',
                'body' => '<p>The University Drama Club is proud to present its latest production: a contemporary adaptation of William Shakespeare\'s beloved comedy "A Midsummer Night\'s Dream." The performances will run from Friday through Sunday at the University Theater.</p>

<p>This production features an all-student cast and crew, with direction by award-winning theater professor Dr. Michael Okonkwo. The adaptation sets the magical story in modern-day Lagos, incorporating elements of Nigerian culture while maintaining the essence of Shakespeare\'s original work.</p>

<p>"We wanted to create something that honors the classic while making it relatable to our audience," explained the student director. "The themes of love, confusion, and magic are universal and timeless."</p>

<p>The production features elaborate costumes, original music composed by students from the Music Department, and innovative staging that promises to transport audiences into the enchanted forest.</p>

<p>Tickets are ₦1,000 for students and ₦2,000 for the general public. All proceeds will support the Drama Club\'s future productions and community outreach programs. Shows begin at 7:00 PM, with a special matinee on Sunday at 3:00 PM.</p>',
                'tags' => 'drama,theater,entertainment,shakespeare,student activities',
                'news_category_id' => 5, // Entertainment
                'featured' => false,
                'image_url' => 'https://images.unsplash.com/photo-1503095396549-807759245b35?w=800&h=600&fit=crop'
            ],
            [
                'title' => 'University Partners with Tech Giants for Student Internship Program',
                'excerpt' => 'Leading technology companies have signed agreements to offer internship opportunities to students from various departments.',
                'body' => '<p>The University has announced exciting new partnerships with several leading technology companies, creating unprecedented internship opportunities for students across multiple departments.</p>

<p>The partnership includes companies such as Microsoft, Google, IBM, and several local tech startups. These organizations will offer internship positions to students in Computer Science, Engineering, Business, and related fields.</p>

<p>"This is a game-changer for our students," said the Dean of Career Services. "These internships provide real-world experience, professional networking opportunities, and often lead to full-time employment after graduation."</p>

<p>The internship program will begin in January 2026, with positions ranging from software development and data analysis to project management and user experience design. Students from 300 to 500 level are eligible to apply.</p>

<p>Application details and requirements will be posted on the university career portal next week. Information sessions will be held in each participating department to guide students through the application process and help them prepare for interviews.</p>',
                'tags' => 'internship,technology,partnership,career,opportunity',
                'news_category_id' => 1, // News
                'featured' => true,
                'image_url' => 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?w=800&h=600&fit=crop'
            ],
            [
                'title' => 'Annual Cultural Festival Celebrates Diversity and Unity',
                'excerpt' => 'Students showcase their rich cultural heritage through music, dance, food, and traditional attire during the week-long festival.',
                'body' => '<p>The University\'s Annual Cultural Festival returned this week, transforming the campus into a vibrant celebration of Nigeria\'s diverse cultural heritage. The week-long event features performances, exhibitions, and activities highlighting the traditions of various ethnic groups.</p>

<p>Students from different regions have prepared traditional dances, musical performances, and fashion shows showcasing authentic cultural attire. The campus grounds host food stalls offering delicacies from across the country, giving everyone a taste of Nigeria\'s culinary diversity.</p>

<p>"The Cultural Festival is one of our most cherished traditions," said the Student Union President. "It reminds us that our diversity is our strength and that we are all united as one university community."</p>

<p>Highlights of the festival include the Traditional Games Competition, Cultural Quiz, Art Exhibition featuring student artwork, and the grand finale cultural night with performances from all participating groups.</p>

<p>The festival is open to all members of the university community and the general public. Special recognition will be given to the best performances in various categories, with prizes sponsored by the university and local businesses.</p>',
                'tags' => 'culture,festival,diversity,tradition,student life',
                'news_category_id' => 2, // Events
                'featured' => false,
                'image_url' => 'https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3?w=800&h=600&fit=crop'
            ],
            [
                'title' => 'New Scholarship Program Launched for Underprivileged Students',
                'excerpt' => 'The university introduces a comprehensive scholarship scheme to support academically excellent students from low-income backgrounds.',
                'body' => '<p>In a move to promote educational equity and access, the University has launched a new comprehensive scholarship program aimed at supporting academically talented students from underprivileged backgrounds.</p>

<p>The "Education for All" scholarship program will provide full tuition coverage, accommodation support, and a monthly stipend for living expenses to 50 deserving students in the first year. The program is expected to expand in subsequent years based on available funding.</p>

<p>"Education should not be a privilege reserved for the wealthy," stated the Vice-Chancellor during the program launch. "This scholarship represents our commitment to ensuring that financial constraints do not prevent talented young people from achieving their dreams."</p>

<p>The scholarship is open to both new and continuing students who demonstrate academic excellence and financial need. Eligible students must maintain a minimum CGPA of 3.5 and actively participate in community service activities.</p>

<p>Applications are now open and will close on November 15th, 2025. Interested students can download the application form from the university website and submit it along with required documentation to the Scholarship Office.</p>',
                'tags' => 'scholarship,education,financial aid,opportunity',
                'news_category_id' => 1, // News
                'featured' => true,
                'image_url' => 'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=800&h=600&fit=crop'
            ],
            [
                'title' => 'Campus WiFi Upgrade: Faster Internet Coming Soon',
                'excerpt' => 'The ICT department announces a major infrastructure upgrade that will significantly improve internet connectivity across campus.',
                'body' => '<p>Great news for the university community! The ICT Department has announced a comprehensive upgrade to the campus WiFi infrastructure that promises to deliver significantly faster and more reliable internet connectivity.</p>

<p>The upgrade, which has been in planning for several months, involves installing new high-speed routers, expanding network coverage to previously underserved areas, and increasing overall bandwidth capacity by 300%.</p>

<p>"We recognize that reliable internet access is essential for modern education," said the Director of ICT Services. "This upgrade will support online learning, research activities, and ensure that our students and staff can stay connected without frustration."</p>

<p>The implementation will be carried out in phases over the next four weeks, with minimal disruption to existing services. New network names and access procedures will be communicated to the university community before each phase goes live.</p>

<p>Key improvements include: expanded coverage in hostels and residential areas, dedicated bandwidth for research activities, improved network security protocols, and 24/7 technical support through the ICT helpdesk.</p>',
                'tags' => 'technology,wifi,internet,infrastructure,ict',
                'news_category_id' => 1, // News
                'featured' => false,
                'image_url' => 'https://images.unsplash.com/photo-1551434678-e076c223a692?w=800&h=600&fit=crop'
            ],
            [
                'title' => 'Health Week: Free Medical Screening and Wellness Activities',
                'excerpt' => 'The university health center organizes a week of free medical checkups, health talks, and fitness activities for the campus community.',
                'body' => '<p>The University Health Center is organizing its annual Health Week, offering free medical screenings and a variety of wellness activities for all members of the campus community.</p>

<p>From Monday through Friday next week, students and staff can access free health screenings including blood pressure checks, blood sugar tests, BMI calculations, and general health consultations. Specialized screenings for vision and dental health will also be available.</p>

<p>"Prevention is better than cure," emphasized the Chief Medical Officer. "Health Week gives everyone an opportunity to understand their health status and take proactive steps toward wellness."</p>

<p>The week will also feature daily health talks on topics including mental health awareness, nutrition and healthy eating, exercise and fitness, stress management, and disease prevention. Fitness instructors will lead free workout sessions each morning at the sports complex.</p>

<p>Additionally, the Health Center will distribute free health education materials, vitamins, and basic first aid supplies. Students can also receive free consultations about managing stress during exams and maintaining healthy lifestyles while on campus.</p>

<p>No appointment is necessary for most services. The Health Center will operate extended hours during Health Week, from 8:00 AM to 6:00 PM daily.</p>',
                'tags' => 'health,wellness,medical,screening,fitness',
                'news_category_id' => 2, // Events
                'featured' => false,
                'image_url' => 'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?w=800&h=600&fit=crop'
            ],
        ];

        foreach ($samplePosts as $postData) {
            $imageUrl = $postData['image_url'];
            unset($postData['image_url']);

            $post = Post::create([
                'user_id' => $user->id,
                'school_id' => $school->id,
                'news_category_id' => $postData['news_category_id'],
                'title' => $postData['title'],
                'excerpt' => $postData['excerpt'],
                'body' => $postData['body'],
                'tags' => $postData['tags'],
                'code' => Str::random(10),
                'featured' => $postData['featured'],
                'is_published' => true,
                'enable_comments' => true,
                'enable_reactions' => true,
                'students' => rand(50, 500),
                'lecturers' => rand(10, 50),
                'staffs' => rand(5, 30),
                'users' => rand(100, 800),
            ]);

            // Add media from URL
            try {
                $post->addMediaFromUrl($imageUrl)
                    ->toMediaCollection('media');
            } catch (\Exception $e) {
                $this->command->warn("Could not add image for post: {$post->title}. Error: {$e->getMessage()}");
            }

            $this->command->info("Created post: {$post->title}");
        }

        $this->command->info('Successfully created 10 sample school news posts!');
    }
}




