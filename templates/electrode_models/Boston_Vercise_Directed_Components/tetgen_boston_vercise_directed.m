clear all
close all

pfad = ['.' filesep];
system([' "' mcpath('tetgen') '.exe' '" -pq -aA -g "' pfad 'final.smesh' '"']);

pfad2 = [pfad 'Contacts' filesep];
for k = 1:9
    file = ['con' num2str(k) '.smesh'];
    system([' "' mcpath('tetgen') '.exe' '" -pq -aA -g "' pfad2 file '"']);
end

pfad2 = [pfad 'Insulations' filesep];
for k = 1:17
    file = ['ins' num2str(k) '.smesh'];
    system([' "' mcpath('tetgen') '.exe' '" -pq -aA -g "' pfad2 file '"']);
end