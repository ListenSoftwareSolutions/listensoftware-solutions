$(function () {
    $('#microtheories_search').keyup(function () {
        var current_query = $('#microtheories_search').val().toUpperCase(); 
        if (current_query !== "") {
            $(".list-group li").hide();
            $(".list-group li").each(function () {
                var current_keyword = $(this).text();
                if (current_keyword.indexOf(current_query) >= 0) {
                    $(this).show();
                };
            });
        } else {
            $(".list-group li").show();
        };
    });
});

$(function () {
    $('#article_search').keyup(function () {
        var current_query = $('#article_search').val().toUpperCase();
        if (current_query !== "") {
            $(".list-group li").hide();
            $(".list-group li").each(function () {
                var current_keyword = $(this).text().toUpperCase();
                if (current_keyword.includes(current_query,0)) {
                    $(this).show();
                };
            });
        } else {
            $(".list-group li").show();
        };
    });
});

$(function () {
    $('#links_search').keyup(function () {
        var current_query = $('#links_search').val().toUpperCase();
        if (current_query !== "") {
            $(".list-group li").hide();
            $(".list-group li").each(function () {
                var current_keyword = $(this).text().toUpperCase();
                if (current_keyword.includes(current_query, 0)) {
                    $(this).show();
                };
            });
        } else {
            $(".list-group li").show();
        };
    });
});
