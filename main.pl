#!/usr/bin/perl
use strict;
use warnings;
use Perl::Tidy;
use Crypt::Random::Source;
my $lets = 'aaaaaaaaabbccddddeeeeeeeeeeeeffggghhiiiiiiiiijkllllmmnnnnnnooooooooppqrrrrrrssssttttttuuuuvvwwxyyz';

sub main {
    intro();
    my @players = getPlayers();
    printf("\nGreat! Now we can play!\n\n");
    while (1) {
        for (0 .. scalar @players - 1) {
            my $pName = $players[$_]->getName();
            my $pLetters = $players[$_]->getLetters();
            printf("$pName, it's your turn!\n");
            printf("Your letters are: $pLetters\n");
            printf("Enter a word to play (or press enter to pass) ");
            my $guess = getUserString();
            if (length $guess == 0) {
                my $newlet = $players[$_]->drawLetter();
                print("You get another letter, \"$newlet\"!\n\n");
            }
            elsif ($players[$_]->checkWord($guess)) {
                printf("Great job!\n\n");
            }
            else {
                printf("Check your letters and try again!\n\n");
                $_ -= 1;
            }
        }
        my @winner = isWinner(@players);
        if (scalar @winner == 1) {
            my $wins = $winner[0];
            printf("$wins wins!!\n");
            return 0;
        } elsif (scalar @winner > 1) {
            printf("It's a tie!\n");
            return 0;
        }
		printf("Okay! Next round!\n\n");
    }
}

sub intro {
    printf("Welcome! Time to play! Try to use all of your letters.\n");
    printf("The first player that uses all of their letters wins!\n\n");
}

sub getPlayers {
    printf("How many players will be playing? ");
    my $num = getUserInt();
    my @array;
    for (0 .. $num -1) {
        my $count = $_ + 1;
        printf("Enter the name for player #$count: ");
        my $name = getUserString();
        my $letters = createLetters();
        my $pObject = new Player($name, $letters);
        push @array, $pObject;
    }
    return @array;
}

sub createLetters {
    my $letters = '';
    for (0 ... 5) {
        $letters = $letters . (substr $lets, int(rand(length $lets)), 1);
    }
    print("Letters: $letters\n");
    return $letters;
}

sub convertToLower {
    my $foo = shift;
    return lc $foo;
}

sub isWinner {
    my @players = @_;
    my @winners;
    for my $player (@players) {
        if (length $player->getLetters() == 0) {
            push @winners, $player->{_name};
        }
    }
    return @winners;
}

sub getUserInt {
    my $num = <ARGV>;
    chomp $num;
    $num = int $num;
    return $num;
}

sub getUserString {
    my $str = <ARGV>;
    chomp $str;
    return $str;
}

main();

package Player;
sub new {
    my $class = shift;
    my $self = {
        _name => shift,
        _letters => shift,
    };
    bless $self, $class;
    return $self;
}

sub getName {
    my $self = shift;
    return $self->{_name};
}

sub getLetters {
    my $self = shift;
    return $self->{_letters};
}

sub drawLetter {
	my $self = shift;
	my $rando = substr $lets, rand(length $lets), 1;
    $self->{_letters} = $self->{_letters} . $rando;
    return $rando;
} 

sub printLetters {
    my $self = shift;
    printf($self->{_letters});
}

sub checkWord {
    my $self = shift;
    my $str = shift;
    my @lst;
    for my $i (0 .. length($str) - 1) {
        my $char = substr($str, $i, 1);
        my $temp = index($self->{_letters}, $char);
        if ($temp == -1) {
            return 0;
        }
        push @lst, $char;
    }
    for (@lst) {
        $self->{_letters} =~ s/$_//;
    }
    return 1;
}
