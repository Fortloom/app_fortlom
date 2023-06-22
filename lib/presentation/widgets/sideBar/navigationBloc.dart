import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortloom/presentation/views/Forum/ForumSection.Dart.dart';
import 'package:fortloom/presentation/views/album/AlbumView.dart';
import 'package:fortloom/presentation/views/event/eventmainview.dart';
import 'package:fortloom/presentation/views/home/homeScreen.dart';
import 'package:fortloom/presentation/views/posts/postScreen.dart';

import '../../views/artist/artistView.dart';
import '../../views/configure/configureview.dart';

enum NavigationEvents { homeScreenClickedEvent, postScreenClickedEvent,EventScreenClickedEvent,ForumScreenClickedEvent,ArtistScreenClickedEvent,
  ConfigureScreenClickedEvent,AlbumScreenClickedEvent }

class NavigationStates {}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  NavigationBloc() : super(const HomeScreen()) {
    on<NavigationEvents>((event, emit) {
      switch (event) {
        case NavigationEvents.homeScreenClickedEvent:
          emit(const HomeScreen());
          break;
        case NavigationEvents.postScreenClickedEvent:
          emit(PostScreen());
          break;
        case NavigationEvents.EventScreenClickedEvent:
          emit(EventMainView());
          break;
        case NavigationEvents.ForumScreenClickedEvent:
          emit(ForumSection());
          break;
        case NavigationEvents.ArtistScreenClickedEvent:
          emit(ArtistView());
          break;
        case NavigationEvents.ConfigureScreenClickedEvent:
          emit(EditProfilePage());
          break;
        case NavigationEvents.AlbumScreenClickedEvent:
          emit(AlbumView());
          break;
      }
    });
  }
}
