(function() {
	var ANCHOR_REGEXP = /\[(.+?)\]\((.+?)\)/g;
	var ANIMATION_DURATION = 500;
	var DEFAULT_EVENT_ICON_CLASSES = 'glyphicon glyphicon-ok';
	var ICON_WIDTH_FRACTION = 0.8;

	var adaptIconWidth = function() {
		var item_width = $('#profiles li').width();
		var font_size = ICON_WIDTH_FRACTION * item_width + 'px';
		$('#profiles i').css({
			'font-size': font_size
		});
	};

	var buildTimeline = function(options) {
		var ul = $('<ul />', {
			'class': 'timeline'
		});
		_.each(options.events, function(event, index) {
			buildTimelineItem({
				event: event,
				exclude: options.exclude,
				index: index
			}).appendTo(ul);
		});
		return ul;
	};

	var buildTimelineItem = function(options) {
		var item = $('<li />', {
			'class': options.index.isEven() ? null : 'timeline-inverted'
		});
		var badge = $('<div />', {
			'class': 'timeline-badge'
		}).appendTo(item);
		$('<i />', {
			'class': options.event.icon || DEFAULT_EVENT_ICON_CLASSES
		}).appendTo(badge);
		var panel = $('<div />', {
			'class': 'timeline-panel'
		}).appendTo(item);
		var heading = $('<div />', {
			'class': 'timeline-heading'
		}).appendTo(panel);
		$('<h3 />', {
			'class': 'timeline-title',
			text: options.event.title
		}).appendTo(heading);
		$('<p />', {
			'class': 'text-muted',
			html: '<i class="fa fa-clock-o"></i>&nbsp;' + (options.event.from ? options.event.from + ' - ' : '') + (options.event.to || 'present')
		}).appendTo(heading);
		if (!_.contains(options.exclude, 'technologies')) {
			$('<p />', {
				html: '<i class="fa fa-rocket"></i>&nbsp;' + options.event.technologies
			}).appendTo(heading);
		}
		$('<div />', {
			'class': 'timeline-body',
			html: options.event.html
		}).appendTo(panel);
		return item;
	};

	var fetchData = function() {
		_.each(['projects', 'studies'], function(element, index) {
			$.ajax({
				dataType: 'json',
				success: function(response) {
					renderTimeline({
						container: $('#' + element),
						events: mapEvents(response),
						exclude: index === 0 ? [] : ['technologies']
					});
				},
				url: '/data/' + element + '.json'
			});
		});
	};

	var initialize = function() {
		adaptIconWidth();
		fetchData();
		handleMailtoLinks();
		scrollSmoothly();
	};

	var handleMailtoLinks = function() {
		$('a.mailto').on('click', function(event) {
			event.preventDefault();
			email_address = $(this).html().replace(' [at] ', '@').replace(' [dot] ', '.');
			window.location.assign('mailto:' + email_address);
		});
	};

	var mapEvents = function(events) {
		return _.map(events, function(event) {
			return _.extend(event, {
				html: event.html.replace(ANCHOR_REGEXP, function(match, text, url) {
					return '<a href="' + url + '" target="_blank">' + text + '</a>';
				})
			});
		});
	};

	var parseEventTime = function(event) {
		if (event.from) {
			var matches = event.from.match(/\w+/g);
			var month = matches[0] - 1;
			var year = matches[1];
			return new Date(year, month).getTime();
		} else {
			return Number.MAX_VALUE;
		}
	};

	var renderTimeline = function(options) {
		var timeline = buildTimeline({
			events: _.sortBy(options.events, function(event) {
				return -parseEventTime(event);
			}),
			exclude: options.exclude
		});
		options.container.children('div.ajax').html(timeline);
	};

	var scrollSmoothly = function() {
		$('a.navbar-brand, ul.nav li a').on('click', function(event) {
			event.preventDefault();
			var hash = this.hash;
			$('body, html').animate({
				scrollTop: $(hash).offset() ? $(hash).offset().top : 0
			}, ANIMATION_DURATION, function() {
				window.location.hash = hash;
			});
		});
	};

	$(function() {
		initialize();
		$(window).resize(adaptIconWidth);
	});
})();
