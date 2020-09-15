class Site::AnswerController < SiteController
  def question
    #@answer = Answer.find(params[:answer_id])
    redis_answer = Rails.cache.read(params[:answer_id]).split("@@")
    @question_id = redis_answer.first
    @correct = ActiveModel::Type::Boolean.new.cast(redis_answer.last)

    UserStatistic.set_statistic(@correct, current_user)
  end

  private

  def set_user_statistic(answer)
    if user_signed_in?
      user_statistic = UserStatistic.find_or_create_by(user: current_user)
      answer.correct? ? user_statistic.right_questions += 1 : user_statistic.wrong_questions += 1
      user_statistic.save
    end
  end
end